require 'spec_helper.rb'

# Note: Using `expect{}.to` notation for transform_attributes() runs into
# difficulties -- rather than accessing the value returned by function, it
# sees the intermediary Proc. Therefore, the trusty `should` is used instead.

describe "transform_attributes", :type => :helper do
  include LogHelper

  context "with unrecognized key" do
    context "during key transformation" do
      subject { transform_attributes(['id_checked_at_time', nil])[0] }
      it { is_expected.not_to include '_' }
      it { is_expected.to include 'I', 'C', 'A', 'T'}
      it { is_expected.to include 'ID' }
      it { is_expected.to eq("ID Checked At Time") }
    end

    context "during value transformation" do
      it "transforms nil to N/A" do
        expect(transform_attributes(['not_an_attribute', nil])[1]).to eq("N/A")
      end
      it "doesn't transform constant values" do
        [1, true, 'true'].each do |x|
          expect(transform_attributes(['not_an_attribute', x])[1]).to eq(x)
        end
      end
    end
  end

  context "with recognized key" do
    it "converts existing reserver/check-in handler/check-out handler ID into proper link" do
      user = FactoryGirl.create(:user)
      %w(reserver_id checkin_handler_id checkout_handler_id).each do |k|
        expect(transform_attributes( [k, user.id] )[1]).to eq(link_to(user.name, User.find(user.id)))
      end
    end

    it "converts non-existent reserver ID into N/A" do
      %w(reserver_id checkin_handler_id checkout_handler_id).each do |k|
        expect(transform_attributes( [k, nil] )[1]).to eq('N/A')
      end
    end

    it "converts existing reservation ID into proper link" do
      res = FactoryGirl.create(:valid_reservation)
      expect(transform_attributes( ['reservation_id', res.id] )[1]).to eq(link_to("#{res.id} (see current)", Reservation.find(res.id)))
    end

    it "doesn't convert defunct reservation ID into proper link" do
      expect(transform_attributes( ['reservation_id', 0] )[1]).to eq("0 (deleted)")
    end

    it "converts existing equipment model ID into proper link" do
      eqm = FactoryGirl.create(:equipment_model)
      expect(transform_attributes( ['equipment_model_id', eqm.id] )[1]).to eq(link_to("#{eqm.name}", EquipmentModel.find(eqm.id)))
    end

    it "doesn't convert defunct equipment model into a link" do
      expect(transform_attributes( ['equipment_model_id', 0] )[1]).to eq("Model ID 0 (deleted)")
    end

    it "converts existing equipment object ID into proper link" do
      eqo = FactoryGirl.create(:equipment_object)
      expect(transform_attributes( ['equipment_object_id', eqo.id] )[1]).to eq(link_to("#{eqo.name}", EquipmentObject.find(eqo.id)))
    end

    it "doesn't convert defunct equipment object into a link" do
      expect(transform_attributes( ['equipment_object_id', 0] )[1]).to eq("N/A")
    end

    it "converts start date and due date to readable form (Mon DD, YYYY)" do
      date = DateTime.now
      %w(start_date due_date).each do |k|
        expect(transform_attributes( [k, date] )[1]).to eq(date.strftime("%B %d, %Y"))
      end
    end

    it "converts creation, update, check-in, and check-out time to readable form" do
      date = DateTime.now
      %w(created_at updated_at checked_in checked_out).each do |k|
        expect(transform_attributes( [k, date] )[1]).to eq(date.strftime("%B %d, %Y, %H:%M:%S, %z"))
      end
    end
  end
end
