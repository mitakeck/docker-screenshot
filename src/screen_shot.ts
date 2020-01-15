import puppeteer from 'puppeteer';
import devices from 'puppeteer/DeviceDescriptors';
import fs from 'fs';

const device = devices['iPhone 5'];

const screenShot = async (url: string, distPath: string) => {
  const browser = await puppeteer.launch({
    headless: true,
    args: [
      '--no-sandbox',
      '--disable-gpu',
      '--window-size=375,812',
      // `--user-agent=${USER_AGENT}`,
    ],
  });

  const page = await browser.newPage();
  await page.emulate(device);
  await page.goto(url, {
    timeout: 0,
    waitUntil: 'networkidle0',
  });

  const screenData = await page.screenshot({
    encoding: 'binary',
    type: 'png',
    fullPage: true,
  });
  fs.writeFileSync(distPath, screenData);

  await page.close();
  await browser.close();
}

export default screenShot;
