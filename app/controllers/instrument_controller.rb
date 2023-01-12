class InstrumentController < ApplicationController
  before_action :set_instrument, only: %i[show edit update destroy]

  # GET /instruments
  def index
    # set the @instruments variable to all instruments
    @instruments = Instrument.all
  end

  # GET /instruments/:id
  def show; end

  # GET /instruments/new
  def new
    @instrument = Instrument.new
  end

  # POST /instruments
  def create
    @instrument = Instrument.new(instrument_params)
    if @instrument.save
      redirect_to @instrument, notice: "#{@instrument.title} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /instruments/:id/edit
  def edit; end

  # PATCH /instruments/:id
  def update
    if @instrument.update(instrument_params)
      redirect_to @instrument, notice: "#{@instrument.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to instruments_path, notice: "#{@instrument.title} was successfully deleted." if @instrument.destroy
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to instruments_path, notice: 'Sorry, assessment instrument not found'
  end

  def instrument_params
    params.require(:instrument).permit(%i[title description sectioned])
  end
end
