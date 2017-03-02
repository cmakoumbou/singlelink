# FriendlyId Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `friendly_id` class method or defining
# methods in your model.
#
# To learn more, check out the guide:
#
# http://norman.github.io/friendly_id/file.Guide.html

FriendlyId.defaults do |config|
  # ## Reserved Words
  #
  # Some words could conflict with Rails's routes when used as slugs, or are
  # undesirable to allow as slugs. Edit this list as needed for your app.
  config.use :reserved

  config.reserved_words = %w(about access account accounts add address adm admin
  administration adult advertising affiliate affiliates ajax analytics android
  admins assets anon anonymous api app apps archive atom auth authentication
  advertise avatar backup banner banners bin billing blog blogs board bot bots
  business chat cache cadastro calendar campaign careers cgi client cliente code
  comercial compare config connect contact contest create code compras css
  dashboard data db design delete design designer dev devel dir directory 
  doc docs domain download downloads edit editor email ecommerce forum forums
  faq favorite feed feedback flog follow file files free ftp gadget gadgets
  games guest group groups help home homepage host hosting hostname html http
  httpd https hpg info information image img images imap index invite intranet
  indice ipad iphone irc java javascript javascripts job jobs js knowledgebase
  log login logs logout list lists links link mail mail1 mail2 mail3 mail4 mail5
  mailer mailing mx manager marketing master me media message microblog microblogs
  mine mp3 msg msn mysql messenger mob mobile movie movies music musicas my name
  named net network new news newsletter nick nickname notes noticiasns ns1 ns2
  ns3 ns4 old online operator order orders page pager pages panel password perl
  pic pics pro photo photos photoalbum php plugin plugins pop pop3 post postmaster
  postfix posts profile project projects promo pub public python premium premiums
  passwords random register registration root ruby rss report sale sales sample
  samples script scripts secure send service shop sql signup signin search security
  settings setting setup site sites sitemap smtp soporte ssh stage staging start
  stripe subscribe subdomain suporte support stat static stats status store stores
  system stylesheets stylesheet session sponsor sponsors tablet tablets tech telnet
  test test1 test2 test3 teste tests theme themes tmp todo task tasks tools tv talk
  update upload url user username usuario usage users vendas video videos visitor
  win ww www www1 www2 www3 www4 www5 www6 www7 wwww wws wwws web webhook webhooks
  webmail website websites webmaster workshop xxx xpg you yourname yourusername
  yoursite yourdomain)

  #  ## Friendly Finders
  #
  # Uncomment this to use friendly finders in all models. By default, if
  # you wish to find a record by its friendly id, you must do:
  #
  #    MyModel.friendly.find('foo')
  #
  # If you uncomment this, you can do:
  #
  #    MyModel.find('foo')
  #
  # This is significantly more convenient but may not be appropriate for
  # all applications, so you must explicity opt-in to this behavior. You can
  # always also configure it on a per-model basis if you prefer.
  #
  # Something else to consider is that using the :finders addon boosts
  # performance because it will avoid Rails-internal code that makes runtime
  # calls to `Module.extend`.
  #
  # config.use :finders
  #
  # ## Slugs
  #
  # Most applications will use the :slugged module everywhere. If you wish
  # to do so, uncomment the following line.
  #
  # config.use :slugged
  #
  # By default, FriendlyId's :slugged addon expects the slug column to be named
  # 'slug', but you can change it if you wish.
  #
  # config.slug_column = 'slug'
  #
  # When FriendlyId can not generate a unique ID from your base method, it appends
  # a UUID, separated by a single dash. You can configure the character used as the
  # separator. If you're upgrading from FriendlyId 4, you may wish to replace this
  # with two dashes.
  #
  # config.sequence_separator = '-'
  #
  #  ## Tips and Tricks
  #
  #  ### Controlling when slugs are generated
  #
  # As of FriendlyId 5.0, new slugs are generated only when the slug field is
  # nil, but if you're using a column as your base method can change this
  # behavior by overriding the `should_generate_new_friendly_id` method that
  # FriendlyId adds to your model. The change below makes FriendlyId 5.0 behave
  # more like 4.0.
  #
  # config.use Module.new {
  #   def should_generate_new_friendly_id?
  #     slug.blank? || <your_column_name_here>_changed?
  #   end
  # }
  #
  # FriendlyId uses Rails's `parameterize` method to generate slugs, but for
  # languages that don't use the Roman alphabet, that's not usually sufficient.
  # Here we use the Babosa library to transliterate Russian Cyrillic slugs to
  # ASCII. If you use this, don't forget to add "babosa" to your Gemfile.
  #
  # config.use Module.new {
  #   def normalize_friendly_id(text)
  #     text.to_slug.normalize! :transliterations => [:russian, :latin]
  #   end
  # }
end
