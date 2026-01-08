const express = require("express");
const app = express();

// IMPORTANT: Express uses uppercase PORT, not lowercase "port"
const PORT = process.env.PORT || 3001;

// Simple health check for ALB
app.get("/", (req, res) => {
  res.status(200).send("OK");
});

// Mapping table: slug → long URL
const links = {
  dashboard: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31",
  events: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/events",
  sessions: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/sessions",
  realtime: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/realtime",
  compare: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/compare",
  breakdown: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/breakdown",
  goals: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/goals",
  funnels: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/funnels",
  journeys: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/journeys",
  retention: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/retention",
  segments: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/segments",
  cohorts: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/cohorts",
  utm: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/utm",
  revenue: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/revenue",
  attribution: "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/attribution"
};

// Redirect handler
app.get("/s/:slug", (req, res) => {
  const slug = req.params.slug;
  const target = links[slug];

  if (target) {
    res.redirect(target);
  } else {
    res.status(404).send("Not found");
  }
});

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Shortener running on port ${PORT}`);
});
