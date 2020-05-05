class HamburguesaController < ApplicationController
    def index
        @hamburguesas = Hamburguesa.all
        @result = []
        @hamburguesas.each do |hamburguesa|
            item = {
                "id" => hamburguesa.id,
                "nombre" => hamburguesa.nombre,
                "precio" => hamburguesa.precio,
                "descripcion" => hamburguesa.descripcion,
                "imagen" => hamburguesa.imagen,
                "ingredientes" => []
            }
            
            hamburguesa.ingredientes.each do |ingrediente|
                item["ingredientes"] << {"path" => "https://hamburguesasapi.herokuapp.com/ingrediente/"+ingrediente.id.to_s}
            end
            @result << item
        end
        render json: @result, status: :ok
    end

    def create
        begin
            body = JSON.parse(request.body.read)
            if body.keys == ["nombre", "precio", "descripcion", "imagen"]
                @hamburguesa = Hamburguesa.new(nombre: body["nombre"], precio: body["precio"].to_i, imagen: body["imagen"], descripcion: body["descripcion"])
                @hamburguesa.save
                @respuesta = {
                    "id" => @hamburguesa.id,
                    "nombre" => @hamburguesa.nombre,
                    "precio" => @hamburguesa.precio,
                    "descripcion" => @hamburguesa.descripcion,
                    "imagen" => @hamburguesa.imagen,
                    "ingredientes" => []
                }
                @hamburguesa.ingredientes.each do |ingrediente|
                    @respuesta['ingredientes'] << {"path" => "https://hamburguesasapi.herokuapp.com/ingrediente/"+ingrediente.id.to_s}
                end
                render json: @respuesta, status: :created
            else 
                render json: {"message" => "input invalido"}, status: :bad_request
            end
        rescue
            render json: {"message" => "input invalido"}, status: :bad_request
        end
    end

    def show
        id = params["id"]
        if id.to_i.to_s == id
            @hamburguesa = Hamburguesa.find_by(id: params["id"])
            if @hamburguesa
                @respuesta = {
                    "id" => @hamburguesa.id,
                    "nombre" => @hamburguesa.nombre,
                    "precio" => @hamburguesa.precio,
                    "descripcion" => @hamburguesa.descripcion,
                    "imagen" => @hamburguesa.imagen,
                    "ingredientes" => []
                }
                @hamburguesa.ingredientes.each do |ingrediente|
                    @respuesta['ingredientes'] << {"path" => "https://hamburguesasapi.herokuapp.com/ingrediente/"+ingrediente.id.to_s}
                end
                render json: @respuesta, status: :ok
            else
                render json: {"message" => "Hamburguesa no encontrada"}, status: :not_found
            end
        else
            render json: {"message" => "id no valido"}, status: :bad_request
        end
    end

    def update
        begin
            body = JSON.parse(request.body.read)
            id = params["id"]
            if id.to_i.to_s == id
                if @hamburguesa = Hamburguesa.find_by(id: params["id"])
                    @hamburguesa.update(body)
                    @hamburguesa.save

                    @respuesta = {
                        "id" => @hamburguesa.id,
                        "nombre" => @hamburguesa.nombre,
                        "precio" => @hamburguesa.precio,
                        "descripcion" => @hamburguesa.descripcion,
                        "imagen" => @hamburguesa.imagen,
                        "ingredientes" => []
                    }
                    @hamburguesa.ingredientes.each do |ingrediente|
                        @respuesta['ingredientes'] << {"path" => "https://hamburguesasapi.herokuapp.com/ingrediente/"+ingrediente.id.to_s}
                    end
                    render json: @respuesta, status: :ok
                else 
                    render json: {"message": "hamburguesa inexistente"}, status: :not_found
                end
            else
                render json: {"message": "id no valido"}, status: :bad_request
            end
        rescue
            render json: {"message": "input no valido"}, status: :bad_request
        end
    end

    def destroy
        id = params["id"]
        if id.to_i.to_s == id
            if @hamburguesa = Hamburguesa.find_by(id: params["id"])
                @hamburguesa.destroy

                render json: {"message": "eliminado exitosamente"}, status: :ok
            else
                render json: {"message": "hamburguesa inexistente"}, status: :not_found
            end
        else
            render json: {"message": "id no valido"}, status: :bad_request
        end
    end

    def edit_ingrediente
        id_hamburguesa = params[:id_hamburguesa]
        id_ingrediente = params[:id_ingrediente]
        if id_ingrediente.to_i.to_s == id_ingrediente and id_hamburguesa.to_i.to_s == id_hamburguesa
            if @hamburguesa = Hamburguesa.find_by(id: id_hamburguesa)
                if @ingrediente = Ingrediente.find_by(id: id_ingrediente)
                    k = false
                    unless @hamburguesa.ingredientes.include?(@ingrediente)
                        k = true
                        @hamburguesa.ingredientes << @ingrediente
                        @hamburguesa.save
                        render json: {"message": "Ingrediente agregado"}, status: :created
                    end
                    if !k
                        render json: {"message": "Ingrediente ya esta en hamburguesa"}, status: :conflict
                    end
                else
                    render json: {"message": "Ingrediente no existente"}, status: :not_found
                end
            else
                render json: {"message": "Hamburguesa no existente"}, status: :not_found
            end
        else
            render json: {"message": "Id de hamburguesa y-o ingrediente invalido(s)"}, status: :bad_request
        end
    end

    def delete_ingrediente
        id_hamburguesa = params[:id_hamburguesa]
        id_ingrediente = params[:id_ingrediente]
        if id_ingrediente.to_i.to_s == id_ingrediente and id_hamburguesa.to_i.to_s == id_hamburguesa
            if @hamburguesa = Hamburguesa.find_by(id: id_hamburguesa)
                if @ingrediente = Ingrediente.find_by(id: id_ingrediente)
                    @hamburguesa.ingredientes.delete(@ingrediente)
                    @hamburguesa.save
                    render json:{"message": "Ingrediente retirado"}, status: :ok
                else
                    render json: {"message": "Ingrediente inexistente en la hamburguesa"}, status: :not_found
                end
            else
                render json: {"message": "Hamburguesa inexistente"}, status: :not_found
            end
        else
            render json: {"message": "Id de hamburguesa y-o ingrediente invalido(s)"}, status: :bad_request
        end
    end
end
