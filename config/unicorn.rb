worker_processes  1
listen            "/home/nybles/app/shared/sockets/nybles.sock", :backlog => 64
timeout           30

working_directory "/home/nybles/app/current"
pid               "/home/nybles/app/shared/pids/unicorn.pid"
stderr_path       "/home/nybles/app/shared/log/unicorn.log"
stdout_path       "/home/nybles/app/shared/log/unicorn.log"
