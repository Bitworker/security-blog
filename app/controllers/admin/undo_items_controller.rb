class Admin::UndoItemsController < Admin::BaseController
  def index
    @undo_items = UndoItem.find(:all,
      :order => 'created_at DESC',
      :limit => 50
    )
  end

  def undo
    item = UndoItem.find(params[:id])
    begin
      object = item.process!

      respond_to do |format|
        format.html {
          flash[:notice] = item.complete_description
          redirect_to(:back)
        }
        format.json {
          render :json => {
            :message => item.complete_description,
            :obj     => object.attributes
          }
        }
      end
    rescue UndoFailed
      msg = "Kann nicht rueckgaengig gemacht werden, das Resultat waere eine inkonsistente Seite (z.B. ein Kommentar ohne Beitrag)"
      respond_to do |format|
        format.html {
          flash[:notice] = msg
          redirect_to(:back)
        }
        format.json {
          render :json => { :message => msg }
        }
      end
    end
  end
end
