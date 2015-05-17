#!/bin/sh
unicorn_pid=`cat tmp/unicorn.pid`
echo "Restarting Unicorn ($unicorn_pid)"
kill -HUP $unicorn_pid

bundle exec unicorn -E production -c ./config/unicorn/production.rb -D
echo "Unicorn restarted"
