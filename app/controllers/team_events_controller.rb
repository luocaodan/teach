class TeamEventsController < ApplicationController
  def new
    @errors = []
    @event = TeamEvent.new
  end

  def create
    @event = classroom.team_events.new event_params
    if @event.save
      redirect_to classroom_team_events_path
    else
      @errors = get_record_errors @event
      render 'new'
    end
  end

  def update
    if current_event.update event_params
      redirect_to classroom_team_event_path
    else
      @errors = get_record_errors @event
      render 'edit'
    end
  end

  def index
    @events = classroom.team_events
  end

  def show
    @event = current_event
  end

  def edit
    @errors = []
    @event = current_event
  end

  def destroy
    current_event.destroy
    redirect_to classroom_team_events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :code)
  end

  def classroom
    Classroom.find(params[:classroom_id])
  end

  def current_event
    classroom.team_events.find(params[:id])
  end
end
