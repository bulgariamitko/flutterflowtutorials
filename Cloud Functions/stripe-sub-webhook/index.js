const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const stripe = require('stripe')('sk_test_');

const app = express();
const db = admin.firestore();

// work in progress