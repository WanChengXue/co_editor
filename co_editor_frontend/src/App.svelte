<script>
    import Router  from 'svelte-spa-router'
    import LoginIn from "./routes/LoginIn.svelte";
  
    // 路由配置
    export const routes = {
      "/": LoginIn,
      "/login": LoginIn,
      // 添加其他路由配置
    };
  </script>
  
<main>
    <Router {routes} />
</main>

  <div id="app"></div>