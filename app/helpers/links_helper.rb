module LinksHelper
  def options_for_default_images
    [
      ['Blogger', 'blogger'],
      ['Facebook', 'facebook'],
      ['Flickr', 'flickr'],
      ['Google', 'google'],
      ['Instagram', 'instagram'],
      ['Linkedin', 'linkedin'],
      ['Medium', 'medium'],
      ['Meerkat', 'meerkat'],
      ['Periscope', 'periscope'],
      ['Pinterest', 'pinterest'],
      ['Reddit', 'reddit'],
      ['Snapchat', 'snapchat'],
      ['Soundcloud', 'soundcloud'],
      ['Tumblr', 'tumblr'],
      ['Twitch', 'twitch'],
      ['Twitter', 'twitter'],
      ['Vimeo', 'vimeo'],
      ['Vine', 'vine'],
      ['Wordpress', 'wordpress'],
      ['Youtube', 'youtube']
    ]
  end

  def nice_url(uri)
    URI.parse(uri).host + URI.parse(uri).path
  end
end


