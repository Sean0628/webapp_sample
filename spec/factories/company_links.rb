# frozen_string_literal: true

FactoryBot.define do
  factory :company_link do
    issuer
    linkedin_url { 'http://linkedin.com/company' }
    youtube_url { 'http://youtube.com/company' }
    instagram_url { 'http://instagram.com/company' }
  end
end
