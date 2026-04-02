import fs from 'fs';
import path from 'path';

export default async function handler(req, res) {
  try {
    const file = path.join(process.cwd(), 'public', 'snapshot.json');
    if (!fs.existsSync(file)) {
      return res.status(200).json({ ok: false, message: 'No snapshot yet' });
    }
    const data = JSON.parse(fs.readFileSync(file, 'utf8'));
    return res.status(200).json(data);
  } catch (err) {
    return res.status(500).json({ ok: false, error: String(err) });
  }
}
