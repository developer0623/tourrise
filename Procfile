web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
jobs: rails jobs:work & rails easybill:listen & wait -n
release: rails db:migrate:with_data
