class Merchants::NumbersController < Merchants::ApplicationController
  before_action :find_note

  def index
    flash[:notice] = "成功更新记事本！"
    @numbers  = Number.all()
  end

  def update
    if @note.update_attributes(note_params)
      flash[:notice] = "成功更新记事本！"
      redirect_to merchants_note_path
    else
      render :show
    end
  end

  private

    def find_note
      @note = current_store.notes.first_or_create
    end

    def note_params
      params.require(:note).permit(:content)
    end
end
