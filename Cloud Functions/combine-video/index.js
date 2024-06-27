// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const ffmpeg = require('fluent-ffmpeg');
const { Storage } = require('@google-cloud/storage');
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const os = require('os');
const { v4: uuidv4 } = require('uuid');
const cors = require('cors');

admin.initializeApp();
const db = admin.firestore();
const storage = new Storage();

exports.createFinalVideo = functions.https.onCall(async (data, context) => {
    const projectID = data.project;

    try {
        // Get project document
        const projectDoc = await db.collection('videos').doc(projectID).get();
        if (!projectDoc.exists) {
            throw new Error('Project document not found.');
        }

        const projectData = projectDoc.data();
        const clips = projectData.clipsDT.map(clip => clip.url);
        const themeReference = projectData.themeReference;

        // Get background image from theme reference
        const themeDoc = await themeReference.get();
        if (!themeDoc.exists) {
            throw new Error('Theme document not found.');
        }
        const backgroundImage = themeDoc.data().pathToImage;

        // Download background image
        const backgroundImagePath = path.join(os.tmpdir(), 'background.jpg');
        const backgroundResponse = await axios({
            url: backgroundImage,
            method: 'GET',
            responseType: 'stream'
        });
        const backgroundWriter = fs.createWriteStream(backgroundImagePath);
        backgroundResponse.data.pipe(backgroundWriter);
        await new Promise((resolve, reject) => {
            backgroundWriter.on('finish', resolve);
            backgroundWriter.on('error', reject);
        });

        // Download and prepare videos
        const videoPaths = [];
        for (const clipUrl of clips) {
            const videoPath = path.join(os.tmpdir(), `${uuidv4()}.mp4`);
            const videoResponse = await axios({
                url: clipUrl,
                method: 'GET',
                responseType: 'stream'
            });
            const videoWriter = fs.createWriteStream(videoPath);
            videoResponse.data.pipe(videoWriter);
            await new Promise((resolve, reject) => {
                videoWriter.on('finish', () => {
                    videoPaths.push(videoPath);
                    resolve();
                });
                videoWriter.on('error', reject);
            });
        }

        // Merge videos with background image
        const finalVideoPath = path.join(os.tmpdir(), 'finalVideo.mp4');
        const ffmpegCommand = ffmpeg();

        videoPaths.forEach(videoPath => {
            ffmpegCommand.input(videoPath);
        });

        ffmpegCommand
            .complexFilter([
                {
                    filter: 'pad',
                    options: {
                        width: 'iw',
                        height: 'ih',
                        x: '(ow-iw)/2',
                        y: '(oh-ih)/2',
                        color: 'black'
                    }
                },
                {
                    filter: 'scale',
                    options: {
                        w: '1280',
                        h: '720',
                        force_original_aspect_ratio: 'increase'
                    }
                },
                {
                    filter: 'overlay',
                    options: {
                        x: '(main_w-overlay_w)/2',
                        y: '(main_h-overlay_h)/2',
                        eof_action: 'repeat'
                    }
                }
            ])
            .on('end', () => {
                console.log('Video processing finished!');
            })
            .on('error', err => {
                console.error('Error processing video:', err);
                throw new Error('Video processing failed.');
            })
            .save(finalVideoPath);

        // Upload final video to Firebase Storage
        const finalVideoName = `videos/${projectID}/finalVideo.mp4`;
        await storage.bucket().upload(finalVideoPath, {
            destination: finalVideoName,
            metadata: {
                metadata: {
                    firebaseStorageDownloadTokens: uuidv4()
                }
            }
        });

        // Clean up temporary files
        videoPaths.forEach(videoPath => fs.unlinkSync(videoPath));
        fs.unlinkSync(backgroundImagePath);
        fs.unlinkSync(finalVideoPath);

        return { success: true, message: 'Video created successfully.' };

    } catch (error) {
        console.error('Error creating final video:', error);
        throw new functions.https.HttpsError('internal', 'Unable to create final video.', error.message);
    }
});
