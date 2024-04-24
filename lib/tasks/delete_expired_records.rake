desc "Delete all tokens that are expired"
task delete_expired_records: :environment do
  res = JwtDenylist.where(exp: ...Time.now).map(&:destroy)
  puts "Deleted all records #{res}"
end