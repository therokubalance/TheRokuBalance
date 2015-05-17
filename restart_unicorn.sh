#!/bin/sh
bundle install
rake db:migrate
rake assets:precompile
unicorn_pid=`cat tmp/unicorn.pid`
echo "Restarting Unicorn ($unicorn_pid)"
kill $unicorn_pid
bundle exec unicorn -E production -c ./config/unicorn/production.rb -D
echo "Unicorn restarted"
