# README

## Development environment

Requirements:
- RVM
- Postgres
- Redis
- Yarn

Install Gems:
```
gem install bundler
bundle install
```

Install javascript libraries
```
yarn
```

Initialize database
```
rake db:create db:migrate
```

Run the application
```
sidekiq
./bin/webpack-dev-server
rails s
```
The UI is available at http://localhost:3000

Run the tests
```
rspec
```

## Architecture

Backend:
- Ruby on Rails
- Sidekiq

Frontend:
- HTML + React

The backend is a pure JSON API.
The work of sending an email is performed via a Sidekiq worker.
Retries are attempted until an email is successfully sent via a provider.

A GET to /api/v1/emails will obtain all emails submitted to the system.
The format of the response is:
```
[
    {
        "id": 2,
        "state": "pending",
        "from_address": "linda@borer.co",
        "to_addresses": [
            "phyllis@mccullough.info",
            "glenna_hills@leffler.name",
            "rylan_dach@andersonmcclure.biz",
            "marcelo_wyman@rolfsonko.com",
            "geraldine@kirlin.org",
            "morton@mitchelllueilwitz.biz",
            "rae@koch.co",
            "mireya_hartmann@streich.name",
            "delphine_hickle@douglasblick.biz",
            "maida@klocko.com"
        ],
        "cc_addresses": [
            "malcolm@smith.io",
            "esther_turner@schamberger.co",
            "camren@nikolauspollich.org",
            "will_littel@koch.info",
            "alexander@kub.net",
            "miouri_schaefer@padberg.com",
            "maude_heaney@ortiz.org",
            "rodolfo@fahey.org",
            "malcolm@quitzon.io",
            "monserrate@spinkawaelchi.name",
            "godfrey@emardmckenzie.name"
        ],
        "bcc_addresses": [
            "kristofer@wittingyost.net",
            "asa@kihn.net",
            "joy@wymanmurray.co",
            "bella@hansenrenner.io",
            "brock_west@wilderman.io",
            "marley@boylecummerata.name",
            "ian@johnson.name",
            "diego_bartell@hermistonhamill.org",
            "alexis@murphy.co",
            "daisy@herzog.net",
            "harry_boehm@treutelkeeling.biz",
            "tiana_abbott@beier.org"
        ],
        "subject": "All right, Mr. DeMille, I'm ready for my closeup.",
        "body": "Vice gentrify organic paleo etsy typewriter farm-to-table. Banh mi hashtag pabst. Franzen lomo irony distillery lo-fi asymmetrical butcher. Viral health pinterest yr actually 8-bit mumblecore. Lumbersexual health cliche next level try-hard organic flannel yuccie.",
        "created_at": "2018-06-04T02:13:28.151Z",
        "updated_at": "2018-06-04T02:13:28.151Z"
    },
    {
        "id": 1,
        "state": "pending",
        "from_address": "rachelle@ruelbosco.info",
        "to_addresses": [
            "leda_zboncak@stokescole.biz"
        ],
        "cc_addresses": [],
        "bcc_addresses": [],
        "subject": "May the force be with you.",
        "body": "Narwhal migas truffaut umami pinterest pop-up +1. Waistcoat chartreuse chambray slow-carb kickstarter banh mi. Etsy austin biodiesel meditation twee. Kombucha deep v next level messenger bag knausgaard hoodie. Roof tilde distillery dreamcatcher. Next level echo post-ironic artisan helvetica normcore. Fingerstache irony hella paleo wolf chillwave fanny pack.",
        "created_at": "2018-06-04T02:12:43.708Z",
        "updated_at": "2018-06-04T02:12:43.708Z"
    }
]
```

A POST to /api/v1/emails will queue an email to be sent.
The server responds with a 200, and the ID of the email in a JSON body if the request was valid or a 4xx otherwise.
The format of the request is:
```
{
	"from_attributes": {"email": "leda_zboncak@stokescole.biz"},
	"to_attributes": [{"email": "rachelle@ruelbosco.info"}, {"email": "ian@johnson.name"}],
	"cc_attributes": [{"email": "diego_bartell@hermistonhamill.org"}],
	"bcc_attributes": [{"email": "alexis@murphy.co"}],
	"subject": "Welcome",
	"body": "Vice gentrify organic paleo etsy typewriter farm-to-table."
}
``` 
Response:
```
{
    "id": 6
}
```

## Environment
The following ENV variables must be set:

MAILGUN_URL - Your mailgun API URL

MAILGUN_API_KEY - Your mailgun API key

SENDGRID_URL - Your sendgrid API URL

SENDGRID_API_KEY - Your sendgrid API key

## TODOs

#### Frontend validation
There is no frontend validation - I did not get time to implement.
For the time being, errors returned from the server are rendered under the submit form.
I would use a frontend validation library so requests are not sent to the server unless all fields are valid.

#### Better user experience

I have used one input field to represent a list of email addresses for to, cc and bcc fields.
This is not user friendly, and given more time I would split this out into separate fields, with + and - buttons.
The user would only enter one email address per input field, and press a button to add another field.
