const express = require('express');
const { S3Client, GetObjectCommand } = require('@aws-sdk/client-s3');
const app = express();

const PORT = process.env.PORT || 3001;
const BUCKET = process.env.UIID_BUCKET;
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

// ===========================
// Health check routes for ALB
// ===========================

// If your TG health check is "/", this makes it pass
app.get("/", (req, res) => {
  res.status(200).send("ok");
});

// If you change TG health check to "/health", this makes it pass
app.get("/health", (req, res) => {
  res.status(200).send("ok");
});

// Feature → path mapping
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

// Route: /website/:feature
app.get('/website/:feature', (req, res) => {
  const { feature } = req.params;

  const uuid = domains["site1"];   // default site
  const path = paths[feature];

  // IMPORTANT: dashboard has path "", so only treat it as missing if undefined
  if (!uuid || path === undefined) {
    return res.status(404).send("Not found");
  }

  const url = `https://umami-analytics.co.uk/websites/${uuid}${path}`;
  res.redirect(url);
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Shortener running on 0.0.0.0:${PORT}`);
});
