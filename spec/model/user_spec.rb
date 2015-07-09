require_relative '../spec_helper'
require_relative '../../model/user'

describe MeteorTracker::Model::User do
  describe 'associations' do
    it 'should have events association' do
      expect(subject.events).to be_empty
    end
  end
  
  describe 'validation' do
    it 'should require login' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:login)
      expect(subject.errors[:login]).to include("can't be blank")
      subject.login = 'user1'
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:login)
    end
    
    it 'should require password_hash' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:password_hash)
      expect(subject.errors[:password_hash]).to include("can't be blank")
      subject.password = 's3cr3t'
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:password_hash)
    end
    
    it 'should require role' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:role)
      expect(subject.errors[:role]).to include("can't be blank")
      subject.role = 'user'
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:role)
    end
    
    it 'should not allow to create user with existing login' do
      user = create(:user)
      subject.login = user.login
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:login)
      expect(subject.errors[:login]).to include('has already been taken')
    end
    
    it 'should validate role' do
      subject.role = 'unknown'
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:role)
      expect(subject.errors[:role]).to include('is not included in the list')
      subject.role = 'admin'
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:role)
    end
  end
  
  describe '.authenticate' do
    let!(:user) { create(:user) }
    
    context 'valid credentials' do
      let(:pass) { attributes_for(:user)[:password] }
      
      it 'should return user' do
        expect(described_class.authenticate(user.login, pass)).to eq(user)
      end
      
      context 'invalid role' do
        it 'should return nil' do
          expect(described_class.authenticate(user.login, pass, :admin)).to be_nil
        end
      end
      
      context 'valid role' do
        it 'should return user' do
          expect(described_class.authenticate(user.login, pass, :user)).to eq(user)
        end
      end
    end
    
    context 'invalid credentials' do
      let(:pass) { 'bad password' }
      
      it 'should return nil' do
        expect(described_class.authenticate(user.login, pass)).to be_nil
      end
    end
  end
  
  describe '#admin?' do
    context 'when admin' do
      let(:user) { build(:admin) }
      
      it 'should return true' do
        expect(user.admin?).to eq(true)
      end
    end
    
    context 'when user' do
      let(:user) { build(:user) }
      
      it 'should return false' do
        expect(user.admin?).to eq(false)
      end
    end
  end
end
