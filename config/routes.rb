# frozen_string_literal: true

Rails.application.routes.draw do
  resources :issuers, only: %i[index show edit]
end
