defmodule CoEditorBackendWeb.LoginController do
    use CoEditorBackendWeb, :controller

    def index(conn, %{username: username, password: password}) do
        # params 中是用户的账号和密码，暂时明文传输吧，至于cookies什么等令牌信息不管暂时

        # 步骤一：身份验证，如果为True，则去sqlite中将这个用户对应的room表返回


        # 步骤二：验证失败，返回
    end


    def authenticate_user(username, password) do
        users = CoEditorBackend.Repo.all(CoEditorBackend.User)
    end

end