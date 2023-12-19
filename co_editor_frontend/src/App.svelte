<script>
    import Router  from 'svelte-spa-router'
    import LoginIn from "./routes/LoginIn.svelte"
    import Home from "./routes/Home.svelte"
    // 路由配置
    export const routes = {
      "/": LoginIn,
      "/home": Home
    };
  </script>
  
<main>
    <Router {routes} />
</main>

<div id="app"></div>