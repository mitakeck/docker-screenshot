import screenShot from './screen_shot';
import { distPath } from './util';

const url = process.argv[2];
if (url === undefined) {
  console.error('please spesify the url');
  process.exit(1);
}

const distFileName = process.argv[3];
if (distFileName === undefined) {
  console.error('please specify the dist file name');
  process.exit(1);
}

screenShot(url, `${distPath}/${distFileName}`)
  .then(() => {
    console.log("done");
  })
  .catch((err: Error) => {
    console.error(err.message);
    process.exit(1);
  });
