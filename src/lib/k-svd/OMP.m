%% OMP implementation
function [A] = OMP(D,Y,tg_sp)



    % perfrom OMP
    for k = 1:size(Y,2)
        Res = Y(:,k);
        Dc = [];
        alpha = [];
        col_num_vec = [];

        % perform OMP for each sample
        for j = 1:tg_sp

            % select atom which is most correlated
            col_num = 0;
            corr = 0; % -Inf;
            for i = 1:size(D,2)
                corr_n = D(:,i)'*Res;
                if(abs(corr_n) > abs(corr))
                    corr = corr_n;
                    col_num = i;
                end
            end

            % store indices of atoms
            col_num_vec = [col_num_vec col_num];

            % add to set
            Dc = [Dc D(:,col_num)];

            P = Dc*inv(Dc'*Dc)*Dc';
            Res = (eye(size(Y,1)) - P)*Y(:,k);

            if sum(Res.^2) < 1e-6
                break;
            end

        end

        alpha_vec = zeros(size(D,2),1);
        alpha_vec(col_num_vec)=inv(Dc'*Dc)*Dc'*Y(:,k);

        A(:,k) = alpha_vec;

    end

end



