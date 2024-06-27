// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require("firebase-admin");
const cors = require('cors')({ origin: true });
const ffmpeg = require('fluent-ffmpeg');
const axios = require('axios');
const { Storage } = require('@google-cloud/storage');
const { tmpdir } = require('os');
const { join } = require('path');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs');

const storage = new Storage();
const db = admin.firestore();

exports.generateThumbnail = functions.runWith({ memory: '512MB' }).https.onRequest((req, res) => {
    cors(req, res, async () => {
        const videoUrl = req.body.videoUrl || (req.body.data && req.body.data.videoUrl);
        const projectID = req.body.projectID || (req.body.data && req.body.data.projectID);

        if (!videoUrl || !projectID) {
            return res.status(400).json({
                error: {
                    message: 'Invalid request, missing videoUrl or projectID.',
                    status: 'INVALID_ARGUMENT',
                },
            });
        }

        try {
            // Get project document
            const videoDoc = db.collection('videos').doc(projectID);
            const doc = await videoDoc.get();
            if (!doc.exists) {
                throw new functions.https.HttpsError('not-found', 'Project document not found.');
            }

            // Get userID from videoOwner field
            const videoOwnerRef = doc.data().videoOwner;
            const videoOwnerDoc = await videoOwnerRef.get();
            const userID = videoOwnerDoc.id;

            console.log(`Downloading video from: ${videoUrl}`);
            const videoResponse = await axios({
                url: videoUrl,
                method: 'GET',
                responseType: 'stream'
            });

            const tempVideoPath = join(tmpdir(), 'video.mp4');
            const writer = fs.createWriteStream(tempVideoPath);
            videoResponse.data.pipe(writer);

            await new Promise((resolve, reject) => {
                writer.on('finish', resolve);
                writer.on('error', reject);
            });

            console.log(`Video downloaded to: ${tempVideoPath}`);

            // Generate thumbnail
            const tempThumbnailPath = join(tmpdir(), 'thumbnail.jpg');
            await new Promise((resolve, reject) => {
                ffmpeg(tempVideoPath)
                    .screenshots({
                        timestamps: ['50%'],
                        filename: 'thumbnail.jpg',
                        folder: tmpdir(),
                        size: '320x?'
                    })
                    .on('end', resolve)
                    .on('error', reject);
            });

            console.log(`Thumbnail generated at: ${tempThumbnailPath}`);

            // Get video length
            const getVideoLength = () => {
                return new Promise((resolve, reject) => {
                    ffmpeg.ffprobe(tempVideoPath, (err, metadata) => {
                        if (err) {
                            reject(err);
                        } else {
                            resolve(metadata.format.duration);
                        }
                    });
                });
            };

            let videoLength = await getVideoLength();
            videoLength = Math.floor(videoLength);
            console.log(`Video length: ${videoLength} seconds`);

            // Upload thumbnail to Firebase Storage
            const bucketName = '[BUCKET].appspot.com';
            const thumbnailFilename = `users/${userID}/uploads/thumbnails/${uuidv4()}.jpg`;
            await storage.bucket(bucketName).upload(tempThumbnailPath, {
                destination: thumbnailFilename,
                metadata: {
                    metadata: {
                        firebaseStorageDownloadTokens: uuidv4(),
                    },
                },
            });
            const thumbnailUrl = `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encodeURIComponent(thumbnailFilename)}?alt=media`;

            // Update Firestore with the thumbnail URL and video length
            const clips = doc.data().clips || [];
            if (clips.length === 0) {
                throw new functions.https.HttpsError('not-found', 'No clips found in the project.');
            }

            const lastClipIndex = clips.length - 1;
            const lastClip = clips[lastClipIndex];
            lastClip.thumbnail = thumbnailUrl;
            lastClip.length = videoLength;

            clips[lastClipIndex] = lastClip;

            await videoDoc.update({
                clips: clips
            });

            // Cleanup temporary files
            fs.unlinkSync(tempVideoPath);
            fs.unlinkSync(tempThumbnailPath);

            res.json({ thumbnailUrl });
        } catch (error) {
            console.error('Error generating thumbnail:', error);
            res.status(500).json({
                error: {
                    message: 'Unable to generate thumbnail.',
                    status: 'INTERNAL',
                },
            });
        }
    });
});
