export default {
  async fetch(request, env, ctx) {
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    if (request.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: corsHeaders,
      });
    }

    try {
      const assetResponse = await env.ASSETS.fetch(request);
      if (assetResponse.status < 400) {
        const response = new Response(assetResponse.body, assetResponse);
        Object.entries(corsHeaders).forEach(([key, value]) => response.headers.set(key, value));
        return response;
      }

      const fallbackRequest = new Request(new URL('/index.html', request.url).toString(), request);
      const fallbackResponse = await env.ASSETS.fetch(fallbackRequest);
      const response = new Response(fallbackResponse.body, fallbackResponse);
      Object.entries(corsHeaders).forEach(([key, value]) => response.headers.set(key, value));
      return response;
    } catch (error) {
      return new Response(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }), {
        status: 500,
        headers: { 'Content-Type': 'application/json', ...corsHeaders },
      });
    }
  },
};
