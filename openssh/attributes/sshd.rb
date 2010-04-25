set_unless[:sshd][:port] = "22"
set_unless[:sshd][:permit_root_login] = false
set_unless[:sshd][:password_auth] = true
set_unless[:sshd][:allow_users] = []
