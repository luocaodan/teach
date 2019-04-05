class AutoTestProjectsController < ApplicationController
  def show
  end

  def feedback
    respond_to do |format|
      format.json do
        test_record_id = params[:test_record_id]
        feedback = params[:feedback]
        test_record = StudentTestRecord.find(test_record_id)
        test_record.feedback = feedback
        test_record.save
        render json: {statue: 'success'}
      end
    end
  end
end
