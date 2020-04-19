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
                if @ingrediente.save
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
        rescue => exception
            
        end
    end
end
