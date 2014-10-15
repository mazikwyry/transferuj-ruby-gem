transferuj-ruby-gem
===================

This is a Ruby Gem for transferuj.pl API. It allows you to create a pay URL simply and validate webhook (payment notification). It's super easy to use and saves you some code. 

## Instalation

```
gem install transferuj
```

or add it to your `Gemfile`:

```
gem 'transferuj'
```

## Usage

### Configuration

First you have to configure gem using your details form transferuj.pl panel. You need your Receiver ID and Secret Code. If you're using Rails you can create initializer file `config/initializers/transferuj.rb'`:

```ruby
Rails.application.config.before_initialize do
	Transferuj.id = 14090
	Transferuj.security_code = 'EAoycw18x2tVo4OU'
end
```

or just set `id` and `security_code` before first usage.

### Sample code (Rails)

The basic usage of transferuj API is redirecting to payment page with some arguments and receiving webhooks (payment notifications).
First read the documentation which you can find [here](https://secure.transferuj.pl/partner/pliki/dokumentacja.pdf).

#### Creating pay URL

If you want to create url to redirect user to payment page just call `pay_url` with parameters. [Here](https://secure.transferuj.pl/partner/pliki/dokumentacja.pdf) you can find list of params. Skip `id` attribute.  

```ruby
def pay
	url = Transferuj.pay_url(
		{
			:kwota => 1,
			:opis => 'Opis transakcji',
			:crc => '124',
			:online => 1,
			:wyn_url => url_for( controller: 'transactions', action: 'webhook', host: 'http://myapp.com'),
			:pow_url => url_for( controller: 'site', action: 'index', host: 'http://myapp.com'),
			:pow_url_blad => url_for( controller: 'site', action: 'index', host: 'http://myapp.com'),
		}
	)
	redirect_to url
end
```

#### Validate webhook

To validate webhook just call `webhook_valid?`. First argument is params hash from POST request, second is IP address of host sending request.

```ruby
def webhook
	if Transferuj.webhook_valid?(params, request.ip)
		#process transaction
		respond_to do |format|
			format.html { render :text => "TRUE" }
		end
	else
		render :status => 404
	end
end
```

## Important!!!

* Enable Test Mode in your transferuj.pl panel.
* You can send test webhooks form your transferuj.pl panel

## Licence

Copyright (c) 2014 Adam Mazur, released under the MIT license


*Feel free to contact me if you need help: mazik.wyry [--a-t--] gmail.com*
