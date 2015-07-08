require_relative '../spec_helper'
require_relative '../../model/event'

describe MeteorTracker::Model::Event do
  describe 'associations' do
    subject { create(:event) }
    
    it 'should belong to user' do
      expect(subject.user).to_not be_nil
    end
    
    it 'should belong to shower' do
      expect(subject.shower).to_not be_nil
    end
  end
  
  describe 'validation' do
    it 'should require user' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:user)
      expect(subject.errors[:user]).to include("can't be blank")
      subject.user = build(:user)
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:user)
    end
    
    it 'should require time' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:time)
      expect(subject.errors[:time]).to include("can't be blank")
      subject.time = attributes_for(:event)[:time]
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:time)
    end
    
    it 'should require right ascention' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:ra)
      expect(subject.errors[:ra]).to include("can't be blank")
      subject.ra = attributes_for(:event)[:ra]
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:ra)
    end
    
    it 'should require declination' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:dec)
      expect(subject.errors[:dec]).to include("can't be blank")
      subject.dec = attributes_for(:event)[:dec]
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:dec)
    end
    
    it 'should require direction' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to include(:dir)
      expect(subject.errors[:dir]).to include("can't be blank")
      subject.dir = attributes_for(:event)[:dir]
      expect(subject.valid?).to eq(false)
      expect(subject.errors.keys).to_not include(:dir)
    end
    
    describe 'direction' do
      before do
        subject.dir = dir
      end
      
      context 'invalid value' do
        let(:dir) { 'invalid' }
        
        it 'should validate direction' do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.keys).to include(:dir)
          expect(subject.errors[:dir]).to include('is not included in the list')
        end
      end
      
      context 'valid value' do
        let(:dir) { attributes_for(:event)[:dir] }
        
        it 'should validate direction' do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.keys).to_not include(:dir)
        end
      end
    end
    
    context 'shower not provided' do
      it 'should not validate shower presence' do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.keys).to_not include(:shower)
      end
    end
    
    context 'shower provided' do
      context 'and existing' do
        it 'should validate shower presence' do
          expect(subject.valid?).to eq(false)
          subject.shower = create(:shower)
          expect(subject.valid?).to eq(false)
          expect(subject.errors.keys).to_not include(:shower)
        end
      end
      
      context 'but not existing' do
        it 'should validate shower presence' do
          expect(subject.valid?).to eq(false)
          subject.shower_id = '99'
          expect(subject.valid?).to eq(false)
          expect(subject.errors.keys).to include(:shower)
          expect(subject.errors[:shower]).to include("can't be blank")
        end
      end
    end
  end
end
