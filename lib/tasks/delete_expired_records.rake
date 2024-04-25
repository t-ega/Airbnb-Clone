desc "Delete all tokens that are expired"
task delete_expired_records: :environment do
  res = JwtDenylist.where('exp < ?', Time.current).destroy_all
  puts "Deleted all records #{res}"
  Token.where('expires_at < ?', Time.current).destroy_all
  res = Token.where(is_used: true).destroy_all
  puts "Deleted all token records #{res}"
end
