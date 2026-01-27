const express = require('express');
const { S3Client, GetObjectCommand } = require('@aws-sdk/client-s3');
const app = express();

const PORT = process.env.PORT || 3001;
const BUCKET = process.env.UIID_BUCKET;      // e.g. "website-uiid"
const KEY = process.env.UIID_KEY || "domains.json";

const s3 = new S3Client({ region: process.env.AWS_REGION });

// Cache for domains
let domains = {};

// Load domains.json from S3
async function loadDomains() {
  try {
    const command = new GetObjectCommand({
      Bucket: BUCKET,
      Key: KEY
    });

    const response = await s3.send(command);
    const body = await response.Body.transformToString();
    domains = JSON.parse(body);

    console.log("Loaded domains from S3:", domains);
  } catch (err) {
    console.error("Failed to load domains from S3:", err);
  }
}

// Load once at startup
loadDomains();

// Optional: refresh every 5 minutes
setInterval(loadDomains, 5 * 60 * 1000);

// Static mapping of features → paths
const paths = {
  dashboard: "",
  events: "/events",
  sessions: "/sessions",
  realtime: "/realtime",
  compare: "/compare",
  breakdown: "/breakdown",
  goals: "/goals",
  funnels: "/funnels",
  journeys: "/journeys",
  retention: "/retention",
  segments: "/segments",
  cohorts: "/cohorts",
  utm: "/utm",
  revenue: "/revenue",
  attribution: "/attribution"
};

// Route: /s/:site/:feature
app.get('/s/:site/:feature', (req, res) => {
  const { site, feature } = req.params;

  const uuid = domains[site];
  const path = paths[feature];

  if (!uuid || !path) {
    return res.status(404).send("Not found");
  }

  const url = `https://umami-analytics.co.uk/websites/${uuid}${path}`;
  res.redirect(url);
});

app.listen(PORT, () => {
  console.log(`Shortener running on port ${PORT}`);
});
