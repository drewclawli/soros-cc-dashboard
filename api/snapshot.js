// In-memory snapshot store (persists for duration of serverless function cold start)
// For true persistence, use Vercel KV or similar — but this works for near-live updates
let currentSnapshot = null;

export default async function handler(req, res) {
  if (req.method === 'POST') {
    // Bot pushes snapshot
    currentSnapshot = req.body;
    currentSnapshot.ok = true;
    currentSnapshot.ts = new Date().toISOString();
    return res.status(200).json({ ok: true, ts: currentSnapshot.ts });
  }

  if (req.method === 'GET') {
    if (currentSnapshot) {
      res.setHeader('Cache-Control', 'no-cache, no-store');
      return res.status(200).json(currentSnapshot);
    }
    return res.status(200).json({ ok: false, error: 'No snapshot yet. Push one via POST.' });
  }

  return res.status(405).json({ error: 'Method not allowed' });
}
