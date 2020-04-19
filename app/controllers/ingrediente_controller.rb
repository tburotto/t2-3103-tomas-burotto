class IngredienteController < ApplicationController
    def index
        @ingredientes = Ingrediente.all
        @result =[]
        @ingredientes.each do |ingrediente|
            item = {
                "id" => ingrediente.id,
                "nombre" => ingrediente.nombre,
                "descripcion" => ingrediente.descripcion
            }
            @result << item
        end
        render json: @result, status: :ok
    end

    def create
        begin
            body = JSON.parse(request.body.read)
            if body.keys == ["nombre", "descripcion"]
                @ingrediente = Ingrediente.new(nombre: body["nombre"], descripcion: body["descripcion"])
                @ingrediente.save
                item = {
                    "id" => @ingrediente.id,
                    "nombre" => @ingrediente.nombre,
                    "descripcion" => @ingrediente.descripcion
                }
                render json: item, status: :created
            else
                render json: {"message": "Input invalido"}, status: :bad_request
            end
        rescue
            render json: {"message": "Input invalido"}, status: :bad_request
        end
    end

    def show
        id = params["id"]
        if id.to_i.to_s == id
            if @ingrediente = Ingrediente.find_by(id: id)
                item = {
                    "id": @ingrediente.id,
                    "nombre": @ingrediente.nombre,
                    "descripcion": @ingrediente.descripcion
                }
                render json: item, status: :ok
            else
                render json: {"message": "Ingrediente inexistente"}, status: :not_found
            end
        else
            render json: {"message": "id invalido"}, status: :bad_request
        end
    end

    def destroy
        id = params["id"]
        if id.to_i.to_s == id
            if @ingrediente = Ingrediente.find_by(id: id)
                if @ingrediente.hamburguesas == []
                    @ingrediente.destroy
                    render json: {"message": "Ingrediente eliminado"}, status: :ok
                else
                    render json: {"message": "Ingrediente no se puede borrar, se encuentra en una hamburguesa"}, status: :conflict
                end
            else
                render json: {"message": "Ingrediente inexistente"}, status: :not_found
            end
        else
            render json: {"message": "id invalido"}, status: :bad_request
        end
    end
end
