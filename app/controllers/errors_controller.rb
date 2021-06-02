class ErrorsController < ApplicationController

  def not_found
    # respond_to do |format|
    #   format.html { render status: 404 }
    #   format.json { render json: { error: "Resource not found" }, status: 404 }
    # end
    render status: 404

    @icons = sidenav_icons(['Хиты продаж'])
    breadcrumb '404', not_found_path
  end

  def unacceptable
    render status: 422
    # respond_to do |format|
    #   format.html { render status: 422 }
    #   format.json { render json: { error: "Params unacceptable" }, status: 422 }
    # end
    @icons = sidenav_icons(['Хиты продаж'])
    breadcrumb '422', unacceptable_path
  end

  def internal_error
    render status: 500
    # respond_to do |format|
    #   format.html { render status: 500 }
    #   format.json { render json: { error: "Internal server error" }, status: 500 }
    # end
    @icons = sidenav_icons(['Хиты продаж'])
    breadcrumb '500', internal_error_path
  end
end