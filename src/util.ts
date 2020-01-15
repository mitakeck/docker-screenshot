export const isDev = process.env.mode !== 'production';
export const distPath = isDev ? './' : '/images';
