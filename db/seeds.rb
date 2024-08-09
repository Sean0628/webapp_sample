# frozen_string_literal: true

# Create external industries
external_industries = 10.times.map do |i|
  ExternalIndustry.create!(name: "External Industry #{i + 1}")
end

# Create industries based on external industries
industries = external_industries.map do |external_industry|
  Industry.create!(name: external_industry.name)
end

# Create external countries
external_countries = 10.times.map do |i|
  ExternalCountry.create!(name: "External Country #{i + 1}")
end

# Create countries based on external countries
external_countries.map do |external_country|
  Country.create!(name: external_country.name)
end

# Create external provinces
external_provinces = 10.times.map do |i|
  ExternalProvince.create!(name: "External Province #{i + 1}")
end

# Create provinces based on external provinces
external_provinces.map do |external_province|
  Province.create!(name: external_province.name)
end

# Create external issuers with associated records
10.times do |i| # rubocop:disable Metrics/BlockLength
  external_issuer = ExternalIssuer.create!(
    name_en: "External Issuer #{i + 1} EN",
    name_fr: "External Issuer #{i + 1} FR",
    description_en: "Description EN for External Issuer #{i + 1}",
    description_fr: "Description FR for External Issuer #{i + 1}",
    logo_url: "https://example.com/logo#{i + 1}.png",
    external_industry_id: external_industries[i].id,
    financial_year_end: Date.new(2023, 12, 31)
  )

  ExternalCompanyLink.create!(
    external_issuer_id: external_issuer.id,
    linkedin_url: "https://linkedin.com/company#{i + 1}",
    youtube_url: "https://youtube.com/channel#{i + 1}",
    instagram_url: "https://instagram.com/profile#{i + 1}"
  )

  ExternalAddress.address_types.each do |address_type, _|
    ExternalAddress.create!(
      external_issuer_id: external_issuer.id,
      external_country_id: external_countries[i].id,
      external_province_id: external_provinces[i].id,
      city: "City #{i + 1}",
      address: "123 Address #{i + 1}",
      zip_code: "12345#{i + 1}",
      address_type:
    )
  end

  ExternalSecurityDetail.create!(
    external_issuer_id: external_issuer.id,
    name_en: "Security Detail #{i + 1} EN",
    name_fr: "Détail de Sécurité #{i + 1} FR",
    issue_outstanding: 1000 + i * 100,
    reserved_for_issuance: 500 + i * 50,
    total_equity_shares_as_if_converted: 1500 + i * 150
  )
end
