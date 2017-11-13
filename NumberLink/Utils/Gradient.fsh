void main() {
    vec4 color = texture2D(u_texture, v_tex_coord);
//
//    float factor = (v_tex_coord.x + v_tex_coord.y) / 2.0;
//    if (angle == 0.0) {
//        factor = v_tex_coord.x;
//    } else if (angle < 0.0) {
//        factor = 1.0 - factor;
//    }
//
//    gl_FragColor = color * vec4(mix(bottomColor, topColor, factor));
    
    vec2 u = v_tex_coord - 0.5;

    float x = 0.5 + length(u) * cos(atan(u.y, -u.x) + angle);

    gl_FragColor = vec4(mix(bottomColor, topColor, smoothstep(0.25, 0.75, x)));
    
}
