defmodule CoEditorBackendWeb.LoginController do
    use CoEditorBackendWeb, :controller


    def index(conn, %{"username"=> username, "password" => password}) do
        # params 中是用户的账号和密码，暂时明文传输吧，至于cookies什么等令牌信息不管暂时
        # %{username: username, password: password}
        # 步骤一：身份验证，如果为True，则去sqlite中将这个用户对应的room表返回
        # 进行相关的处理逻辑
        response = case authenticate_user(username, password) do
            {:ok, _user} ->
                # 令牌生成功能暂时空缺，使用固定令牌
                %{status: true, token: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NT
                Y3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.u3pH0Kc6t3i6b6eZfTlRQwIqKxJ8WfTzAd96T8
                Fs4e3YVcW9p0aR3UQ6nFvHvJ2sM0eVcP4IYJKGjUjgZP7A"}
            _ ->
                %{status: false, error_message: "user not found or user not exist"}
        end
        conn
        |> put_status(:ok)
        |> json(response)
    end


    defp authenticate_user(username, password) do
        users = CoEditorBackend.Repo.all(CoEditorBackend.User)
        case Enum.find(users, fn user -> user.username == username && user.password == password end) do
            nil ->
            # 用户名和密码不匹配
            {:error, "用户名或密码不正确"}
            user ->
            # 用户名和密码匹配
            {:ok, user}
        end
        # {:ok, "alice"}
    end

end
