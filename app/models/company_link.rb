# frozen_string_literal: true

class CompanyLink < ApplicationRecord # :nodoc:
  URL_REGEX = URI::DEFAULT_PARSER.make_regexp(%w[http https])

  belongs_to :issuer

  validates :issuer, presence: true
  validates :linkedin_url, :youtube_url, :instagram_url,
            format: { with: URL_REGEX, message: 'must be a valid URL' },
            allow_blank: true
end
