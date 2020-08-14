FactoryBot.define do 
  factory :conductor_electrico, :class => Electrico::Conductor do
    izth { 100}
    alma { 'Cu' }
    tservicio { 90 }
    grupo {'A'}
    seccion { 10 }
    Iz { 100 }
    tamb { 30 }
    after(:create) do |conductor_electrico, evaluator|
     #  $logger.info "Conductor Eléctrico factory create izth= #{conductor_electrico.izth}A-AWG=#{conductor_electrico.awg}-Iz#{conductor_electrico.Iz}A-seccion#{conductor_electrico.seccion}mm2"
    end
  end

  factory :conductor, :class => Electrico::Conductor do 
    id { 3104 }  
    izth { 10000 } 
    alma { 'Cu'} 
    tservicio { 90 }
    grupo  { 'A'}  
    seccion { 10 } 
    Iz      { 10000} 
    tamb    { 30 } 
    after(:create) do |conductor, evaluator|  
     #  $logger.info "Conductor Factory Creado izth= #{conductor.izth}A-AWG= #{conductor.awg}-Iz=#{conductor.Iz}A-seccion #{conductor.seccion}mm2"
    end
     factory :conductor_2885 do
       id      { 2885 } 
       izth    { 16 }
       seccion { 2.08 }
       awg     { 14 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 20.0}
    end

     factory :conductor_2886 do
       id      { 2886 } 
       izth    { 20 }
       seccion { 3.31 }
       awg     { 12 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 25.0}
    end

     factory :conductor_2887 do
       id      { 2887 } 
       izth    { 32 }
       seccion { 5.26 }
       awg     { 10 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 30.0}
    end

     factory :conductor_2888 do
       id      { 2888 } 
       izth    { 40 }
       seccion { 8.37 }
       awg     { 8 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 40.0}
    end

     factory :conductor_2889 do
       id      { 2889 } 
       izth    { 55 }
       seccion { 13.3 }
       awg     { 6 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 55.0}
    end

     factory :conductor_2890 do
       id      { 2890 } 
       izth    { 70 }
       seccion { 21.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 70.0}
    end

     factory :conductor_2891 do
       id      { 2891 } 
       izth    { 85 }
       seccion { 26.7 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 85.0}
    end

     factory :conductor_2892 do
       id      { 2892 } 
       izth    { 95 }
       seccion { 33.6 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 95.0}
    end

     factory :conductor_2893 do
       id      { 2893 } 
       izth    { 110 }
       seccion { 42.4 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 110.0}
    end

     factory :conductor_2894 do
       id      { 2894 } 
       izth    { 125 }
       seccion { 53.5 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 125.0}
    end

     factory :conductor_2895 do
       id      { 2895 } 
       izth    { 145 }
       seccion { 67.4 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 145.0}
    end

     factory :conductor_2896 do
       id      { 2896 } 
       izth    { 165 }
       seccion { 85.0 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 165.0}
    end

     factory :conductor_2897 do
       id      { 2897 } 
       izth    { 195 }
       seccion { 107.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 195.0}
    end

     factory :conductor_2898 do
       id      { 2898 } 
       izth    { 215 }
       seccion { 126.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 215.0}
    end

     factory :conductor_2899 do
       id      { 2899 } 
       izth    { 240 }
       seccion { 151.8 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 240.0}
    end

     factory :conductor_2900 do
       id      { 2900 } 
       izth    { 250 }
       seccion { 177.3 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 250.0}
    end

     factory :conductor_2901 do
       id      { 2901 } 
       izth    { 280 }
       seccion { 202.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 280.0}
    end

     factory :conductor_2902 do
       id      { 2902 } 
       izth    { 320 }
       seccion { 253.2 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 320.0}
    end

     factory :conductor_2903 do
       id      { 2903 } 
       izth    { 355 }
       seccion { 303.6 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 355.0}
    end

     factory :conductor_2904 do
       id      { 2904 } 
       izth    { 385 }
       seccion { 354.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 385.0}
    end

     factory :conductor_2905 do
       id      { 2905 } 
       izth    { 400 }
       seccion { 379.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 400.0}
    end

     factory :conductor_2906 do
       id      { 2906 } 
       izth    { 410 }
       seccion { 405.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 410.0}
    end

     factory :conductor_2907 do
       id      { 2907 } 
       izth    { 435 }
       seccion { 456.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 435.0}
    end

     factory :conductor_2908 do
       id      { 2908 } 
       izth    { 455 }
       seccion { 506.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 455.0}
    end

     factory :conductor_2909 do
       id      { 2909 } 
       izth    { 495 }
       seccion { 633.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 495.0}
    end

     factory :conductor_2910 do
       id      { 2910 } 
       izth    { 520 }
       seccion { 750.1 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 520.0}
    end

     factory :conductor_2911 do
       id      { 2911 } 
       izth    { 545 }
       seccion { 886.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 545.0}
    end

     factory :conductor_2912 do
       id      { 2912 } 
       izth    { 560 }
       seccion { 10013.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 560.0}
    end

     factory :conductor_2913 do
       id      { 2913 } 
       izth    { 16 }
       seccion { 2.08 }
       awg     { 14 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 25.0}
    end

     factory :conductor_2914 do
       id      { 2914 } 
       izth    { 20 }
       seccion { 3.31 }
       awg     { 12 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 30.0}
    end

     factory :conductor_2915 do
       id      { 2915 } 
       izth    { 32 }
       seccion { 5.26 }
       awg     { 10 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 40.0}
    end

     factory :conductor_2916 do
       id      { 2916 } 
       izth    { 60 }
       seccion { 8.37 }
       awg     { 8 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 60.0}
    end

     factory :conductor_2917 do
       id      { 2917 } 
       izth    { 80 }
       seccion { 13.3 }
       awg     { 6 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 80.0}
    end

     factory :conductor_2918 do
       id      { 2918 } 
       izth    { 105 }
       seccion { 21.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 105.0}
    end

     factory :conductor_2919 do
       id      { 2919 } 
       izth    { 120 }
       seccion { 26.7 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 120.0}
    end

     factory :conductor_2920 do
       id      { 2920 } 
       izth    { 140 }
       seccion { 33.6 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 140.0}
    end

     factory :conductor_2921 do
       id      { 2921 } 
       izth    { 165 }
       seccion { 42.4 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 165.0}
    end

     factory :conductor_2922 do
       id      { 2922 } 
       izth    { 195 }
       seccion { 53.5 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 195.0}
    end

     factory :conductor_2923 do
       id      { 2923 } 
       izth    { 225 }
       seccion { 67.4 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 225.0}
    end

     factory :conductor_2924 do
       id      { 2924 } 
       izth    { 260 }
       seccion { 85.0 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 260.0}
    end

     factory :conductor_2925 do
       id      { 2925 } 
       izth    { 300 }
       seccion { 107.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 300.0}
    end

     factory :conductor_2926 do
       id      { 2926 } 
       izth    { 340 }
       seccion { 126.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 340.0}
    end

     factory :conductor_2927 do
       id      { 2927 } 
       izth    { 375 }
       seccion { 151.8 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 375.0}
    end

     factory :conductor_2928 do
       id      { 2928 } 
       izth    { 420 }
       seccion { 177.3 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 420.0}
    end

     factory :conductor_2929 do
       id      { 2929 } 
       izth    { 455 }
       seccion { 202.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 455.0}
    end

     factory :conductor_2930 do
       id      { 2930 } 
       izth    { 515 }
       seccion { 253.2 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 515.0}
    end

     factory :conductor_2931 do
       id      { 2931 } 
       izth    { 575 }
       seccion { 303.6 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 575.0}
    end

     factory :conductor_2932 do
       id      { 2932 } 
       izth    { 630 }
       seccion { 354.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 630.0}
    end

     factory :conductor_2933 do
       id      { 2933 } 
       izth    { 655 }
       seccion { 379.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 655.0}
    end

     factory :conductor_2934 do
       id      { 2934 } 
       izth    { 680 }
       seccion { 405.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 680.0}
    end

     factory :conductor_2935 do
       id      { 2935 } 
       izth    { 730 }
       seccion { 456.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 730.0}
    end

     factory :conductor_2936 do
       id      { 2936 } 
       izth    { 780 }
       seccion { 506.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 780.0}
    end

     factory :conductor_2937 do
       id      { 2937 } 
       izth    { 890 }
       seccion { 633.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 890.0}
    end

     factory :conductor_2938 do
       id      { 2938 } 
       izth    { 980 }
       seccion { 750.1 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 980.0}
    end

     factory :conductor_2939 do
       id      { 2939 } 
       izth    { 1070 }
       seccion { 886.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1070.0}
    end

     factory :conductor_2940 do
       id      { 2940 } 
       izth    { 1155 }
       seccion { 10013.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 60}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1155.0}
    end

     factory :conductor_2941 do
       id      { 2941 } 
       izth    { 16 }
       seccion { 2.08 }
       awg     { 14 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 20.0}
    end

     factory :conductor_2942 do
       id      { 2942 } 
       izth    { 20 }
       seccion { 3.31 }
       awg     { 12 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 25.0}
    end

     factory :conductor_2943 do
       id      { 2943 } 
       izth    { 32 }
       seccion { 5.26 }
       awg     { 10 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 35.0}
    end

     factory :conductor_2944 do
       id      { 2944 } 
       izth    { 50 }
       seccion { 8.37 }
       awg     { 8 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 50.0}
    end

     factory :conductor_2945 do
       id      { 2945 } 
       izth    { 65 }
       seccion { 13.3 }
       awg     { 6 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 65.0}
    end

     factory :conductor_2946 do
       id      { 2946 } 
       izth    { 85 }
       seccion { 21.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 85.0}
    end

     factory :conductor_2947 do
       id      { 2947 } 
       izth    { 100 }
       seccion { 26.7 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 100.0}
    end

     factory :conductor_2948 do
       id      { 2948 } 
       izth    { 115 }
       seccion { 33.6 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 115.0}
    end

     factory :conductor_2949 do
       id      { 2949 } 
       izth    { 130 }
       seccion { 42.4 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 130.0}
    end

     factory :conductor_2950 do
       id      { 2950 } 
       izth    { 150 }
       seccion { 53.5 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 150.0}
    end

     factory :conductor_2951 do
       id      { 2951 } 
       izth    { 175 }
       seccion { 67.4 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 175.0}
    end

     factory :conductor_2952 do
       id      { 2952 } 
       izth    { 200 }
       seccion { 85.0 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 200.0}
    end

     factory :conductor_2953 do
       id      { 2953 } 
       izth    { 230 }
       seccion { 107.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 230.0}
    end

     factory :conductor_2954 do
       id      { 2954 } 
       izth    { 255 }
       seccion { 126.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 255.0}
    end

     factory :conductor_2955 do
       id      { 2955 } 
       izth    { 285 }
       seccion { 151.8 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 285.0}
    end

     factory :conductor_2956 do
       id      { 2956 } 
       izth    { 310 }
       seccion { 177.3 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 310.0}
    end

     factory :conductor_2957 do
       id      { 2957 } 
       izth    { 335 }
       seccion { 202.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 335.0}
    end

     factory :conductor_2958 do
       id      { 2958 } 
       izth    { 380 }
       seccion { 253.2 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 380.0}
    end

     factory :conductor_2959 do
       id      { 2959 } 
       izth    { 420 }
       seccion { 303.6 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 420.0}
    end

     factory :conductor_2960 do
       id      { 2960 } 
       izth    { 460 }
       seccion { 354.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 460.0}
    end

     factory :conductor_2961 do
       id      { 2961 } 
       izth    { 475 }
       seccion { 379.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 475.0}
    end

     factory :conductor_2962 do
       id      { 2962 } 
       izth    { 490 }
       seccion { 405.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 490.0}
    end

     factory :conductor_2963 do
       id      { 2963 } 
       izth    { 520 }
       seccion { 456.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 520.0}
    end

     factory :conductor_2964 do
       id      { 2964 } 
       izth    { 545 }
       seccion { 506.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 545.0}
    end

     factory :conductor_2965 do
       id      { 2965 } 
       izth    { 590 }
       seccion { 633.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 590.0}
    end

     factory :conductor_2966 do
       id      { 2966 } 
       izth    { 625 }
       seccion { 750.1 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 625.0}
    end

     factory :conductor_2967 do
       id      { 2967 } 
       izth    { 650 }
       seccion { 886.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 650.0}
    end

     factory :conductor_2968 do
       id      { 2968 } 
       izth    { 665 }
       seccion { 10013.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 665.0}
    end

     factory :conductor_2969 do
       id      { 2969 } 
       izth    { 16 }
       seccion { 2.08 }
       awg     { 14 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 30.0}
    end

     factory :conductor_2970 do
       id      { 2970 } 
       izth    { 20 }
       seccion { 3.31 }
       awg     { 12 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 35.0}
    end

     factory :conductor_2971 do
       id      { 2971 } 
       izth    { 32 }
       seccion { 5.26 }
       awg     { 10 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 50.0}
    end

     factory :conductor_2972 do
       id      { 2972 } 
       izth    { 70 }
       seccion { 8.37 }
       awg     { 8 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 70.0}
    end

     factory :conductor_2973 do
       id      { 2973 } 
       izth    { 95 }
       seccion { 13.3 }
       awg     { 6 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 95.0}
    end

     factory :conductor_2974 do
       id      { 2974 } 
       izth    { 125 }
       seccion { 21.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 125.0}
    end

     factory :conductor_2975 do
       id      { 2975 } 
       izth    { 145 }
       seccion { 26.7 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 145.0}
    end

     factory :conductor_2976 do
       id      { 2976 } 
       izth    { 170 }
       seccion { 33.6 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 170.0}
    end

     factory :conductor_2977 do
       id      { 2977 } 
       izth    { 195 }
       seccion { 42.4 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 195.0}
    end

     factory :conductor_2978 do
       id      { 2978 } 
       izth    { 230 }
       seccion { 53.5 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 230.0}
    end

     factory :conductor_2979 do
       id      { 2979 } 
       izth    { 265 }
       seccion { 67.4 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 265.0}
    end

     factory :conductor_2980 do
       id      { 2980 } 
       izth    { 310 }
       seccion { 85.0 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 310.0}
    end

     factory :conductor_2981 do
       id      { 2981 } 
       izth    { 360 }
       seccion { 107.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 360.0}
    end

     factory :conductor_2982 do
       id      { 2982 } 
       izth    { 405 }
       seccion { 126.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 405.0}
    end

     factory :conductor_2983 do
       id      { 2983 } 
       izth    { 445 }
       seccion { 151.8 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 445.0}
    end

     factory :conductor_2984 do
       id      { 2984 } 
       izth    { 505 }
       seccion { 177.3 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 505.0}
    end

     factory :conductor_2985 do
       id      { 2985 } 
       izth    { 545 }
       seccion { 202.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 545.0}
    end

     factory :conductor_2986 do
       id      { 2986 } 
       izth    { 620 }
       seccion { 253.2 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 620.0}
    end

     factory :conductor_2987 do
       id      { 2987 } 
       izth    { 690 }
       seccion { 303.6 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 690.0}
    end

     factory :conductor_2988 do
       id      { 2988 } 
       izth    { 755 }
       seccion { 354.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 755.0}
    end

     factory :conductor_2989 do
       id      { 2989 } 
       izth    { 785 }
       seccion { 379.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 785.0}
    end

     factory :conductor_2990 do
       id      { 2990 } 
       izth    { 815 }
       seccion { 405.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 815.0}
    end

     factory :conductor_2991 do
       id      { 2991 } 
       izth    { 870 }
       seccion { 456.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 870.0}
    end

     factory :conductor_2992 do
       id      { 2992 } 
       izth    { 935 }
       seccion { 506.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 935.0}
    end

     factory :conductor_2993 do
       id      { 2993 } 
       izth    { 1065 }
       seccion { 633.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1065.0}
    end

     factory :conductor_2994 do
       id      { 2994 } 
       izth    { 1175 }
       seccion { 750.1 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1175.0}
    end

     factory :conductor_2995 do
       id      { 2995 } 
       izth    { 1280 }
       seccion { 886.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1280.0}
    end

     factory :conductor_2996 do
       id      { 2996 } 
       izth    { 1385 }
       seccion { 10013.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 75}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1385.0}
    end

     factory :conductor_2997 do
       id      { 2997 } 
       izth    { 16 }
       seccion { 2.08 }
       awg     { 14 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 25.0}
    end

     factory :conductor_2998 do
       id      { 2998 } 
       izth    { 20 }
       seccion { 3.31 }
       awg     { 12 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 30.0}
    end

     factory :conductor_2999 do
       id      { 2999 } 
       izth    { 32 }
       seccion { 5.26 }
       awg     { 10 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 40.0}
    end

     factory :conductor_3000 do
       id      { 3000 } 
       izth    { 55 }
       seccion { 8.37 }
       awg     { 8 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 55.0}
    end

     factory :conductor_3002 do
       id      { 3002 } 
       izth    { 95 }
       seccion { 21.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 95.0}
    end

     factory :conductor_3003 do
       id      { 3003 } 
       izth    { 110 }
       seccion { 26.7 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 110.0}
    end

     factory :conductor_3004 do
       id      { 3004 } 
       izth    { 130 }
       seccion { 33.6 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 130.0}
    end

     factory :conductor_3005 do
       id      { 3005 } 
       izth    { 150 }
       seccion { 42.4 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 150.0}
    end

     factory :conductor_3006 do
       id      { 3006 } 
       izth    { 170 }
       seccion { 53.5 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 170.0}
    end

     factory :conductor_3007 do
       id      { 3007 } 
       izth    { 195 }
       seccion { 67.4 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 195.0}
    end

     factory :conductor_3008 do
       id      { 3008 } 
       izth    { 225 }
       seccion { 85.0 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 225.0}
    end

     factory :conductor_3009 do
       id      { 3009 } 
       izth    { 260 }
       seccion { 107.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 260.0}
    end

     factory :conductor_3010 do
       id      { 3010 } 
       izth    { 290 }
       seccion { 126.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 290.0}
    end

     factory :conductor_3011 do
       id      { 3011 } 
       izth    { 320 }
       seccion { 151.8 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 320.0}
    end

     factory :conductor_3012 do
       id      { 3012 } 
       izth    { 350 }
       seccion { 177.3 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 350.0}
    end

     factory :conductor_3013 do
       id      { 3013 } 
       izth    { 380 }
       seccion { 202.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 380.0}
    end

     factory :conductor_3014 do
       id      { 3014 } 
       izth    { 430 }
       seccion { 253.2 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 430.0}
    end

     factory :conductor_3015 do
       id      { 3015 } 
       izth    { 475 }
       seccion { 303.6 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 475.0}
    end

     factory :conductor_3016 do
       id      { 3016 } 
       izth    { 520 }
       seccion { 354.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 520.0}
    end

     factory :conductor_3017 do
       id      { 3017 } 
       izth    { 535 }
       seccion { 379.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 535.0}
    end

     factory :conductor_3018 do
       id      { 3018 } 
       izth    { 555 }
       seccion { 405.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 555.0}
    end

     factory :conductor_3019 do
       id      { 3019 } 
       izth    { 585 }
       seccion { 456.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 585.0}
    end

     factory :conductor_3020 do
       id      { 3020 } 
       izth    { 615 }
       seccion { 506.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 615.0}
    end

     factory :conductor_3021 do
       id      { 3021 } 
       izth    { 665 }
       seccion { 633.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 665.0}
    end

     factory :conductor_3022 do
       id      { 3022 } 
       izth    { 705 }
       seccion { 750.1 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 705.0}
    end

     factory :conductor_3023 do
       id      { 3023 } 
       izth    { 735 }
       seccion { 886.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 735.0}
    end

     factory :conductor_3024 do
       id      { 3024 } 
       izth    { 750 }
       seccion { 10013.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 750.0}
    end

     factory :conductor_3025 do
       id      { 3025 } 
       izth    { 16 }
       seccion { 2.08 }
       awg     { 14 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 35.0}
    end

     factory :conductor_3026 do
       id      { 3026 } 
       izth    { 20 }
       seccion { 3.31 }
       awg     { 12 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 40.0}
    end

     factory :conductor_3027 do
       id      { 3027 } 
       izth    { 32 }
       seccion { 5.26 }
       awg     { 10 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 55.0}
    end

     factory :conductor_3028 do
       id      { 3028 } 
       izth    { 80 }
       seccion { 8.37 }
       awg     { 8 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 80.0}
    end

     factory :conductor_3029 do
       id      { 3029 } 
       izth    { 105 }
       seccion { 13.3 }
       awg     { 6 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 105.0}
    end

     factory :conductor_3030 do
       id      { 3030 } 
       izth    { 140 }
       seccion { 21.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 140.0}
    end

     factory :conductor_3031 do
       id      { 3031 } 
       izth    { 165 }
       seccion { 26.7 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 165.0}
    end

     factory :conductor_3032 do
       id      { 3032 } 
       izth    { 190 }
       seccion { 33.6 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 190.0}
    end

     factory :conductor_3033 do
       id      { 3033 } 
       izth    { 220 }
       seccion { 42.4 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 220.0}
    end

     factory :conductor_3034 do
       id      { 3034 } 
       izth    { 260 }
       seccion { 53.5 }
       awg     { 1 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 260.0}
    end

     factory :conductor_3035 do
       id      { 3035 } 
       izth    { 300 }
       seccion { 67.4 }
       awg     { 2 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 300.0}
    end

     factory :conductor_3036 do
       id      { 3036 } 
       izth    { 350 }
       seccion { 85.0 }
       awg     { 3 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 350.0}
    end

     factory :conductor_3037 do
       id      { 3037 } 
       izth    { 405 }
       seccion { 107.2 }
       awg     { 4 }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 405.0}
    end

     factory :conductor_3038 do
       id      { 3038 } 
       izth    { 455 }
       seccion { 126.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 455.0}
    end

     factory :conductor_3039 do
       id      { 3039 } 
       izth    { 505 }
       seccion { 151.8 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 505.0}
    end

     factory :conductor_3040 do
       id      { 3040 } 
       izth    { 570 }
       seccion { 177.3 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 570.0}
    end

     factory :conductor_3041 do
       id      { 3041 } 
       izth    { 615 }
       seccion { 202.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 615.0}
    end

     factory :conductor_3042 do
       id      { 3042 } 
       izth    { 700 }
       seccion { 253.2 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 700.0}
    end

     factory :conductor_3043 do
       id      { 3043 } 
       izth    { 780 }
       seccion { 303.6 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 780.0}
    end

     factory :conductor_3044 do
       id      { 3044 } 
       izth    { 855 }
       seccion { 354.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 855.0}
    end

     factory :conductor_3045 do
       id      { 3045 } 
       izth    { 885 }
       seccion { 379.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 885.0}
    end

     factory :conductor_3046 do
       id      { 3046 } 
       izth    { 920 }
       seccion { 405.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 920.0}
    end

     factory :conductor_3047 do
       id      { 3047 } 
       izth    { 985 }
       seccion { 456.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 985.0}
    end

     factory :conductor_3048 do
       id      { 3048 } 
       izth    { 1055 }
       seccion { 506.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1055.0}
    end

     factory :conductor_3049 do
       id      { 3049 } 
       izth    { 1200 }
       seccion { 633.4 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1200.0}
    end

     factory :conductor_3050 do
       id      { 3050 } 
       izth    { 1325 }
       seccion { 750.1 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1325.0}
    end

     factory :conductor_3051 do
       id      { 3051 } 
       izth    { 1455 }
       seccion { 886.7 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1455.0}
    end

     factory :conductor_3052 do
       id      { 3052 } 
       izth    { 1560 }
       seccion { 10013.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'B'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 1560.0}
    end

     factory :conductor_3053 do
       id      { 3053 } 
       izth    { 11 }
       seccion { 1.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 11.0}
    end

     factory :conductor_3054 do
       id      { 3054 } 
       izth    { 15 }
       seccion { 1.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 15.0}
    end

     factory :conductor_3055 do
       id      { 3055 } 
       izth    { 20 }
       seccion { 2.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 20.0}
    end

     factory :conductor_3056 do
       id      { 3056 } 
       izth    { 25 }
       seccion { 4.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 25.0}
    end

     factory :conductor_3057 do
       id      { 3057 } 
       izth    { 33 }
       seccion { 6.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 33.0}
    end

     factory :conductor_3058 do
       id      { 3058 } 
       izth    { 45 }
       seccion { 10.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 45.0}
    end

     factory :conductor_3059 do
       id      { 3059 } 
       izth    { 61 }
       seccion { 16.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 61.0}
    end

     factory :conductor_3060 do
       id      { 3060 } 
       izth    { 83 }
       seccion { 25.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 83.0}
    end

     factory :conductor_3061 do
       id      { 3061 } 
       izth    { 103 }
       seccion { 35.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 103.0}
    end

     factory :conductor_3062 do
       id      { 3062 } 
       izth    { 132 }
       seccion { 50.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 132.0}
    end

     factory :conductor_3063 do
       id      { 3063 } 
       izth    { 164 }
       seccion { 70.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 164.0}
    end

     factory :conductor_3064 do
       id      { 3064 } 
       izth    { 197 }
       seccion { 95.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 197.0}
    end

     factory :conductor_3065 do
       id      { 3065 } 
       izth    { 235 }
       seccion { 120.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'1'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 235.0}
    end

     factory :conductor_3066 do
       id      { 3066 } 
       izth    { 12 }
       seccion { 0.75 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 12.0}
    end

     factory :conductor_3067 do
       id      { 3067 } 
       izth    { 15 }
       seccion { 1.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 15.0}
    end

     factory :conductor_3068 do
       id      { 3068 } 
       izth    { 19 }
       seccion { 1.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 19.0}
    end

     factory :conductor_3069 do
       id      { 3069 } 
       izth    { 25 }
       seccion { 2.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 25.0}
    end

     factory :conductor_3070 do
       id      { 3070 } 
       izth    { 34 }
       seccion { 4.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 34.0}
    end

     factory :conductor_3071 do
       id      { 3071 } 
       izth    { 44 }
       seccion { 6.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 44.0}
    end

     factory :conductor_3072 do
       id      { 3072 } 
       izth    { 61 }
       seccion { 10.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 61.0}
    end

     factory :conductor_3073 do
       id      { 3073 } 
       izth    { 82 }
       seccion { 16.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 82.0}
    end

     factory :conductor_3074 do
       id      { 3074 } 
       izth    { 108 }
       seccion { 25.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 108.0}
    end

     factory :conductor_3075 do
       id      { 3075 } 
       izth    { 134 }
       seccion { 35.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 134.0}
    end

     factory :conductor_3076 do
       id      { 3076 } 
       izth    { 167 }
       seccion { 50.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 167.0}
    end

     factory :conductor_3077 do
       id      { 3077 } 
       izth    { 207 }
       seccion { 70.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 207.0}
    end

     factory :conductor_3078 do
       id      { 3078 } 
       izth    { 249 }
       seccion { 95.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 249.0}
    end

     factory :conductor_3079 do
       id      { 3079 } 
       izth    { 291 }
       seccion { 120.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 291.0}
    end

     factory :conductor_3080 do
       id      { 3080 } 
       izth    { 327 }
       seccion { 150.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 327.0}
    end

     factory :conductor_3081 do
       id      { 3081 } 
       izth    { 274 }
       seccion { 185.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 274.0}
    end

     factory :conductor_3082 do
       id      { 3082 } 
       izth    { 442 }
       seccion { 240.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 442.0}
    end

     factory :conductor_3083 do
       id      { 3083 } 
       izth    { 510 }
       seccion { 300.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'2'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 510.0}
    end

     factory :conductor_3084 do
       id      { 3084 } 
       izth    { 15 }
       seccion { 0.75 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 15.0}
    end

     factory :conductor_3085 do
       id      { 3085 } 
       izth    { 19 }
       seccion { 1.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 19.0}
    end

     factory :conductor_3086 do
       id      { 3086 } 
       izth    { 23 }
       seccion { 1.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 23.0}
    end

     factory :conductor_3087 do
       id      { 3087 } 
       izth    { 32 }
       seccion { 2.5 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 32.0}
    end

     factory :conductor_3088 do
       id      { 3088 } 
       izth    { 42 }
       seccion { 4.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 42.0}
    end

     factory :conductor_3089 do
       id      { 3089 } 
       izth    { 54 }
       seccion { 6.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 54.0}
    end

     factory :conductor_3090 do
       id      { 3090 } 
       izth    { 73 }
       seccion { 10.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 73.0}
    end

     factory :conductor_3091 do
       id      { 3091 } 
       izth    { 98 }
       seccion { 16.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 98.0}
    end

     factory :conductor_3092 do
       id      { 3092 } 
       izth    { 129 }
       seccion { 25.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 129.0}
    end

     factory :conductor_3093 do
       id      { 3093 } 
       izth    { 158 }
       seccion { 35.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 158.0}
    end

     factory :conductor_3094 do
       id      { 3094 } 
       izth    { 197 }
       seccion { 50.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 197.0}
    end

     factory :conductor_3095 do
       id      { 3095 } 
       izth    { 244 }
       seccion { 70.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 244.0}
    end

     factory :conductor_3096 do
       id      { 3096 } 
       izth    { 291 }
       seccion { 95.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 291.0}
    end

     factory :conductor_3097 do
       id      { 3097 } 
       izth    { 343 }
       seccion { 120.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 343.0}
    end

     factory :conductor_3098 do
       id      { 3098 } 
       izth    { 382 }
       seccion { 150.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 382.0}
    end

     factory :conductor_3099 do
       id      { 3099 } 
       izth    { 436 }
       seccion { 185.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 436.0}
    end

     factory :conductor_3100 do
       id      { 3100 } 
       izth    { 516 }
       seccion { 240.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 516.0}
    end

     factory :conductor_3101 do
       id      { 3101 } 
       izth    { 595 }
       seccion { 300.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 595.0}
    end

     factory :conductor_3102 do
       id      { 3102 } 
       izth    { 708 }
       seccion { 400.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 708.0}
    end

     factory :conductor_3103 do
       id      { 3103 } 
       izth    { 809 }
       seccion { 500.0 }
       awg     {  }
       tamb    { 30 }
       grupo   {'3'}
       tservicio { 70}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 809.0}
    end

     factory :conductor_3001 do
       id      { 3001 } 
       izth    { 75 }
       seccion { 13.3 }
       awg     { 6 }
       tamb    { 30 }
       grupo   {'A'}
       tservicio { 90}
       alma    {'Cu'}
       espesor { 0.0}
       Iz      { 75.0}
    end

  end
end
