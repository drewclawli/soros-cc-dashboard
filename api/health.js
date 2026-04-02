export default async function handler(req, res) {
  res.status(200).json({ ok: true, service: 'soros-monitor', ts: new Date().toISOString() });
}
