const express =require('express');
const app = express()
const PORT =process.env.port || 30001;

// Mapping table: slug → long URL
const links = {
  "dashboard": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31",
  "events": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/events",
  "sessions": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/sessions",
  "realtime": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/realtime",
  "compare": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/compare",
  "breakdown": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/breakdown",
  "goals": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/goals",
  "funnels": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/funnels",
  "journeys": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/journeys",
  "retention": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/retention",
  "segments": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/segments",
  "cohorts": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/cohorts",
  "utm": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/utm",
  "revenue": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/revenue",
  "attribution": "https://umami-analytics.co.uk/websites/08787023-029b-47cb-8ff9-e197ee146a31/attribution"
};


app.get('/s/:slug', (req, res) => {
  const slug = req.params.slug;
  const target = links[slug];
  if (target) {
    res.redirect(target);
  } else {
    res.status(404).send('Not found');
  }
});

app.listen(PORT, () => {
  console.log(`Shortener running on port ${PORT}`);
});