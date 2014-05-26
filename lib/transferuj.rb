module Transferuj

	class Error < Exception; attr_accessor :errors; end
	
  # ID of receiver
  @@id = ''
  @@security_code = ''
  def self.id=(new_id)
    @@id = new_id
  end

  def self.id
    @@id
  end

  # Security code
  def self.security_code=(new_security_code)
    @@security_code = new_security_code
  end

  def self.security_code
    @@security_code
  end

	# Creates URL for redirection to pay page
	def self.pay_url(params = {})
		self.sanity_check!
		md5sum = Digest::MD5.hexdigest(self.id.to_s+params[:kwota].to_s+params[:crc].to_s+self.security_code.to_s)
		params.merge!({:id => self.id, :md5sum => md5sum})
		URI::HTTP.build(:host => "secure.transferuj.pl", :query => params.to_query).to_s
	end

  # Checks MD5 checksum and IP of request
	def self.webhook_valid?(transaction, ip)
		self.sanity_check!
		md5sum = Digest::MD5.hexdigest(self.id.to_s+transaction[:tr_id].to_s+transaction[:tr_amount].to_s+transaction[:tr_crc].to_s+self.security_code.to_s)
		binding.pry
    ip == '195.149.229.109' && transaction[:md5sum] == md5sum
	end

	def self.configured?
    self.id.present? && self.security_code.present?
  end

  def self.sanity_check!
    unless configured?
      raise Exception.new("Transferuj Gem not properly configured. See README to get help how to do it.")
    end
  end

end