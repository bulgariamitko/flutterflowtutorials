// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://www.youtube.com/watch?v=ZVCAw2JHZ_Y
// replace - [{"Main domain": "mail.example.com"}, {"Sender email": "demo@example.com"}, {"Email password": "myPassword"}, {"Field name to display name": "displayName"}]
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

// const emailPassword = functions.config().email.password;

const transporter = nodemailer.createTransport({
  host: 'mail.example.com',
  port: 465,
  secure: true,
  auth: {
    user: 'demo@example.com',
    pass: 'myPassword',
  },
});

exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
  const mailOptions = {
    from: 'demo@example.com',
    to: user.email,
    subject: 'Welcome to My App',
    text: `Hi ${user.displayName || ''}, welcome to My App! Let us know if you have any questions.`,
  };

  return transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error('There was an error while sending the email:', error);
    } else {
      console.log('Welcome email sent to:', user.email);
    }
  });
});