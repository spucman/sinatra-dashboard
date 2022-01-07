# frozen_string_literal: true

require 'date'
require 'validator'

describe 'EmailValidator' do
  it 'nil is not allowed' do
    expect(mail?(nil)).to eq(false)
  end

  it 'blank is not allowed' do
    expect(mail?('')).to eq(false)
  end

  it 'email pattern must be placed' do
    expect(mail?('notanemail')).to eq(false)
    expect(mail?('some@email')).to eq(true)
  end
end

describe 'RoleValidator' do
  it 'nil is not valid' do
    expect(valid_role?(nil)).to eq(false)
  end

  it 'blank is not valid' do
    expect(valid_role?('')).to eq(false)
  end

  it 'pro / basic are allowed' do
    expect(valid_role?('pro')).to eq(true)
    expect(valid_role?('PRO')).to eq(true)
    expect(valid_role?('pRo')).to eq(true)
    expect(valid_role?('basic')).to eq(true)
    expect(valid_role?('BASIC')).to eq(true)
    expect(valid_role?('baSIC')).to eq(true)
  end
end

describe 'NumberValidator' do
  it 'nil is not valid' do
    expect(number_between?(nil, 1, 3)).to eq(false)
  end

  it 'blank is not valid' do
    expect(number_between?('', 0, 7)).to eq(false)
  end

  it 'boarders are included' do
    expect(number_between?('5', 1, 5)).to eq(true)
    expect(number_between?(1, 1, 5)).to eq(true)
  end

  it 'outside the range is invalid' do
    expect(number_between?('6', 1, 5)).to eq(false)
    expect(number_between?('1', 2, 5)).to eq(false)
  end
end

describe 'TimeValidator' do
  it 'nil is not valid' do
    expect(in_the_past?(nil, nil)).to eq(false)
    expect(in_the_past?('12', nil)).to eq(false)
    expect(in_the_past?(nil, '2020')).to eq(false)
  end

  it 'blank is not valid' do
    expect(in_the_past?('', '')).to eq(false)
    expect(in_the_past?('12', '')).to eq(false)
    expect(in_the_past?('', '2020')).to eq(false)
  end

  it 'current week is not allowed' do
    now = Date.today
    expect(in_the_past?(now.cweek, now.year)).to eq(false)
  end

  it 'future weeks are not allowed' do
    future = Date.today.next_day(7)
    expect(in_the_past?(future.cweek, future.year)).to eq(false)
    future = future.next_year(2)
    expect(in_the_past?(future.cweek, future.year)).to eq(false)
  end

  it 'past is allowed' do
    last_week = Date.today.prev_day(7)
    expect(in_the_past?(last_week.cweek, last_week.year)).to eq(true)
  end
end
