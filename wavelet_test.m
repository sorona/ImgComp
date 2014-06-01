function wavelet_test(Im,Wpar)
    [Ap,H,V,D,Wpar] = WaveletEncode(Im,Wpar);
    Im_rec = WaveletDecode(Ap,H,V,D,Wpar);
    Err = norm(double(Im)-Im_rec,'fro');
    if(Err>10e-6);
        error('Wavelet Encode Test Failed');
    end
    figure();
    subplot(1,2,1);imshow(Im_rec,[]);title('Original');
    subplot(1,2,2);imshow(Im_rec,[]);title('Reconstruction');
    suptitle(sprintf('Wavelet Encode Decode Test, Recostrunction Err = %e',Err))
end