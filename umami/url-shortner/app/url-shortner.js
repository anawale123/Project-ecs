const express = require('express');
const { S3Client, GetObjectCommand } = require('@aws-sdk/client-s3');

const app = express();

const PORT = process.env.PORT || 3001;
const BUCKET = process.env.UIID_BUCKET;
const KEY = process.env.UIID_KEY || "domains.json";
const REGION = process.env.AWS_REGION;

const s3 = new S3Client({ region: REGION });

let domains = {};

async function loadDomains() {
  console.log("loadDomains() called");
  console.log("ENV:", { BUCKET, KEY, REGION });

  try {
    const command = new GetObjectCommand({ Bucket: BUCKET, Key: KEY });
    console.log("Attempting S3 getObject...");
    const response = await s3.send(command);

    const body = await response.Body.transformToString();
    domains = JSON.parse(body);

    console.log("Loaded domains from S3:", domains);
  } catch (err) {
    console.error("Failed to load domains from S3:", err);
  }
}

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

async function start() {
  console.log("Starting shortener service...");

  await loadDomains();

  setInterval(loadDomains, 5 * 60 * 1000);

  app.listen(PORT, () => {
    console.log(`Shortener running on port ${PORT}`);
  });
}

start().catch(err => {
  console.error("Fatal startup error:", err);
});
