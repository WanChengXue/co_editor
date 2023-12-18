<script>
    let username = "";
    let password = "";

    function handleLogin() {
        // mock返回结果
        console.log("mock");
    }
</script>

<main>
    <h1>Login Page</h1>

    <form on:submit|preventDefault={handleLogin}>
        <label>
            Username:
            <input type="text" bind:value={username} />
        </label>

        <label>
            Password:
            <input type="password" bind:value={password} />
        </label>

        <button type="submit">Login</button>
    </form>
</main>

<style>
    main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
    }

    form {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    label {
        display: flex;
        flex-direction: column;
    }

    input {
        padding: 0.5rem;
    }

    button {
        padding: 0.5rem 1rem;
    }
</style>
