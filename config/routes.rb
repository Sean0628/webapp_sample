# frozen_string_literal: true

Rails.application.routes.draw do
  resources :issuers, only: %i[index show edit]
  resources :edit_requests, only: %i[index create]
end
