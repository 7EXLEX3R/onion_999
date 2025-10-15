const http = require('http');
const express = require('express');
const {createProxyMiddleware} = require('http-proxy-middleware');
const app = express();
const CLEARNET_URL = process.env.CLEARNET_URL;
if (!CLEARNET_URL) {
    console.error("❌ error: CLEARNET_URL environment variable not set.");
    process.exit(1);
}
app.use('/', createProxyMiddleware({
    target: CLEARNET_URL,
    changeOrigin: true,
    ws: true,
    pathRewrite: {'^/': '/'},
    onProxyReq(proxyReq) {
        proxyReq.setHeader('host', new URL(CLEARNET_URL).host);
    },
}));
http.createServer(app).listen(80, () => console.log(`🦇 proxy server to ${CLEARNET_URL} running on http://localhost`));